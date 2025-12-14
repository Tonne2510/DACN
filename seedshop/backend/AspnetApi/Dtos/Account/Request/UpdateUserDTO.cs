using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Account.Request
{
    public class UpdateUserDTO
    {
        
        public string? Username { get; set; }
        public string? Phone { get; set; }
        public string? Address { get; set; }
        public string? Gender { get; set; }
    }
}
