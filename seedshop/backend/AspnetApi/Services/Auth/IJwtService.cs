using AspnetApi.Dtos.Auth;
using AspnetApi.Dtos.Auth.Request;
using AspnetApi.Dtos.Auth.Response;
using AspnetApi.Models;

namespace AspnetApi.Services.Auth
{
    public interface IJwtService
    {
        Task<AuthResult> GenerateToken(Account user);
        Task<RefreshTokenResponseDTO> VerifyToken(TokenRequestDTO tokenRequest);
    }
}
