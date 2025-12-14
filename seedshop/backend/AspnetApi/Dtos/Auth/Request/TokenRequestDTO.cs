using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Auth.Request
{
    public class TokenRequestDTO
    {
        [Required]
        public string Token { get; set; }
        [Required]
        public string RefreshToken { get; set; }
    }
}
