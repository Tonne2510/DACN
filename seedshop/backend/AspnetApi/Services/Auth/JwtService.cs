using AspnetApi.Config;
using AspnetApi.Data;
using AspnetApi.Dtos.Auth;
using AspnetApi.Dtos.Auth.Request;
using AspnetApi.Dtos.Auth.Response;
using AspnetApi.Models;
using AspnetApi.Services.User;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace AspnetApi.Services.Auth
{
    public class JwtService : IJwtService
    {
        private readonly JwtConfig _jwtConfig;
        private readonly ApiDbContext _context;
        private readonly TokenValidationParameters _tokenValidationParameters;
        private readonly UserCService _userService;
        public JwtService(IOptionsMonitor<JwtConfig> jwtConfig, ApiDbContext context, UserCService userService, TokenValidationParameters tokenValidationParameters)
        {
            _jwtConfig = jwtConfig.CurrentValue;
            _context = context;
            _tokenValidationParameters = tokenValidationParameters;
            _userService = userService;
        }


        public async Task<AuthResult> GenerateToken(Account user)
        {

            JwtSecurityTokenHandler? jwtTokenHandler = new JwtSecurityTokenHandler();
            IList<string> userRoles = await _userService.GetUserRoles(user.Id);

            byte[] key = Encoding.ASCII.GetBytes(_jwtConfig.Secret);

            var claims = new List<Claim>
            {
                    new Claim("Id", user.Id),
                    new Claim(JwtRegisteredClaimNames.Email, user.Email),
                    new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                    new Claim(JwtRegisteredClaimNames.Name, user.UserName),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new Claim(ClaimTypes.Role, userRoles.First())
            };

            var claimsIdentity = new ClaimsIdentity(claims);

            SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = claimsIdentity,
                 Expires = DateTime.UtcNow.AddHours(24),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)

            };
            //create token
            SecurityToken? token = jwtTokenHandler.CreateToken(tokenDescriptor);
            string jwtToken = jwtTokenHandler.WriteToken(token);

            //create refresh Token
            RefreshToken refreshToken = new RefreshToken()
            {
                JwtId = token.Id,
                IsUsed = false,
                IsRevoked = false,
                UserId = user.Id,
                CreatedAt = DateTime.UtcNow,
                ExpiredAt = DateTime.UtcNow,
                Token = GetRandomString() + Guid.NewGuid()
            };
            await _context.RefreshTokens.AddAsync(refreshToken);
            await _context.SaveChangesAsync();

            return new AuthResult()
            {
                Token = jwtToken,
                RefreshToken = refreshToken.Token,
                Success = true
            };
        }

        public async Task<RefreshTokenResponseDTO> VerifyToken(TokenRequestDTO tokenRequest)
        {
            JwtSecurityTokenHandler? jwtTokenHandler = new JwtSecurityTokenHandler();

            try
            {
                RefreshToken? storedToken = await _context.RefreshTokens.FirstOrDefaultAsync(t => tokenRequest.Token == tokenRequest.RefreshToken);

                if (storedToken == null)
                {
                    return new RefreshTokenResponseDTO()
                    {
                        Success = false,
                        Errors = new List<string>()
                        {
                            "Token does not found"
                        }
                    };

                }

                ClaimsPrincipal? tokenVerification = jwtTokenHandler.ValidateToken(tokenRequest.Token, _tokenValidationParameters, out var validatedToken);

                var jti = tokenVerification.Claims.FirstOrDefault(t => t.Type == JwtRegisteredClaimNames.Jti).Value;

                if (storedToken.JwtId != jti)
                {
                    return new RefreshTokenResponseDTO()
                    {
                        Success = false,
                        Errors = new List<string>()
                        {
                            "Token doesn't match"
                        }
                    };

                }

                long utcExpireDate = long.Parse(tokenVerification.Claims.FirstOrDefault(d => d.Type == JwtRegisteredClaimNames.Exp).Value);

                DateTime expireDate = UTCtoDateTime(utcExpireDate);

                if (expireDate > DateTime.UtcNow)
                {
                    return new RefreshTokenResponseDTO()
                    {
                        Success = false,
                        Errors = new List<string>()
                        {
                            "Token not expired"
                        }
                    };
                }


                if (validatedToken is JwtSecurityToken jwtSecurityToken)
                {
                    bool result = jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase);//?

                    if (!result)
                    {
                        return null;
                    }
                }
                if (storedToken.IsUsed)
                {
                    return new RefreshTokenResponseDTO()
                    {
                        Success = false,
                        Errors = new List<string>{
                     "token used."
                    }
                    };
                }
                ////////////////
                if (storedToken.IsRevoked)
                {
                    return new RefreshTokenResponseDTO()
                    {
                        Success = false,
                        Errors = new List<string>{
                     "token revoked."
                    }
                    };
                }

                storedToken.IsUsed = true;
                _context.RefreshTokens.Update(storedToken);
                await _context.SaveChangesAsync();

                return new RefreshTokenResponseDTO()
                {
                    UserId = storedToken.UserId,
                    Success = true
                };




            }
            catch (Exception e)
            {

                return new RefreshTokenResponseDTO()
                {
                    Errors = new List<string>{
                    e.Message
                },
                    Success = false
                };
            }
        }
        private DateTime UTCtoDateTime(long unixTimeStamp)
        {
            var datetimeVal = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

            datetimeVal = datetimeVal.AddSeconds(unixTimeStamp).ToLocalTime();

            return datetimeVal;
        }

        private string GetRandomString()
        {
            Random random = new Random();
            string chars = "ABCDEFGHIJKLMNOPRSTUVYZWX0123456789";
            return new string(Enumerable.Repeat(chars, 35).Select(n => n[new Random().Next(n.Length)]).ToArray());

        }
    }
}
