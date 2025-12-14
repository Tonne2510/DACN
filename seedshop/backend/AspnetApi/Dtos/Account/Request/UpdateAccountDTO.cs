using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Account.Request
{
    public class UpdateAccountDTO
    {
        [Required]
        public string Email { get; set; }
        [Required]
        public string Username { get; set; }
        [Required]
        public string Password { get; set; }
        [Required]
        public string Role { get; set; }

        public string? Phone { get; set; }
        public string? Address { get; set; }
        public string? Gender { get; set; }
        public IFormFile? Avatar { get; set; }
    }
}
