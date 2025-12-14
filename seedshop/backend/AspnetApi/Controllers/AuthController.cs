using AspnetApi.Dtos.Auth;
using AspnetApi.Dtos.Auth.Request;
using AspnetApi.Dtos.Auth.Response;
using AspnetApi.Models;
using AspnetApi.Services.Auth;
using AutoMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace AspnetApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        // Identity package
        private readonly UserManager<Account> _userManager;
        private readonly IJwtService _jwtService;
        private readonly IMapper _mapper;

        public AuthController(UserManager<Account> userManager, IJwtService jwtService, IMapper mapper)
        {
            _userManager = userManager;
            _jwtService = jwtService;
            _mapper = mapper;
        }


        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterUserDTO user)
        {
            if (ModelState.IsValid)
            {
                var passwordValidator = new PasswordValidator<Account>();
                var passwordValidationResult = await passwordValidator.ValidateAsync(_userManager, null, user.Password);

                if (!passwordValidationResult.Succeeded)
                {
                    return BadRequest(new RegisterResponseDTO()
                    {
                        Errors = new List<string>() { "Password does not meet requirements" },
                        Success = false
                    });
                }
                IdentityUser existingUser = await _userManager.FindByEmailAsync(user.Email);

                if (existingUser != null)
                {
                    return BadRequest(new RegisterResponseDTO()
                    {
                        Errors = new List<string>() { "Email already Registered" },
                        Success = false
                    });
                }

                Account newUser = new Account()
                {
                    Email = user.Email,
                    UserName = user.Username,
                };

                IdentityResult? created = await _userManager.CreateAsync(newUser, user.Password);

               
                if (created.Succeeded)
                {
                    await _userManager.AddToRoleAsync(newUser, "User");

                    AuthResult authResult = await _jwtService.GenerateToken(newUser);
                    //return a token
                    return Ok(authResult);
                }
                else
                {
                    return BadRequest(new RegisterResponseDTO()
                    {
                        Errors = created.Errors.Select(e => e.Description).ToList(),
                        Success = false
                    });
                }
            }

            return BadRequest(new RegisterResponseDTO()
            {
                Errors = new List<string>() { "Invalid payload" },
                Success = false
            });
        }



        [HttpPost("login")]
public async Task<IActionResult> Login(LoginUserDTO user)
{
if (ModelState.IsValid)
{
  IdentityUser existingUser = await _userManager.FindByEmailAsync(user.Email);

  if (existingUser == null)
  {
      return BadRequest(new RegisterResponseDTO()
      {
          Errors = new List<string>() { "Email address is not registered." },
          Success = false
      });
  }
  var login = _mapper.Map<Account>(existingUser);
  bool isUserCorrect = await _userManager.CheckPasswordAsync(login, user.Password);
  if (isUserCorrect)
  {
      AuthResult authResult = await _jwtService.GenerateToken(login);
      //return a token
      return Ok(authResult);
  }
  else
  {
      return BadRequest(new RegisterResponseDTO()
      {
          Errors = new List<string>() { "Wrong password" },
          Success = false
      });
  }
}

return BadRequest(new RegisterResponseDTO()
{
  Errors = new List<string>() { "Invalid payload" },
  Success = false
});
}

[HttpPost("refreshtoken")]
public async Task<IActionResult> RefreshToken([FromBody] TokenRequestDTO tokenRequest)
{
if (ModelState.IsValid)
{
  var verified = await _jwtService.VerifyToken(tokenRequest);
  //
  if (!verified.Success)
  {
      return BadRequest(new AuthResult()
      {
          // Errors = new List<string> { "invalid Token" },
          Errors = verified.Errors,
          Success = false
      });
  }

  var tokenUser = await _userManager.FindByIdAsync(verified.UserId);
  var login = _mapper.Map<Account>(tokenUser);
  AuthResult authResult = await _jwtService.GenerateToken(login);
  //return a token
  return Ok(authResult);


}

return BadRequest(new AuthResult()
{
  Errors = new List<string> { "invalid Payload" },
  Success = false
});



}
}
}
