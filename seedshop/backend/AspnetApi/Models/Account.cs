using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Models
{
    public class Account : IdentityUser
    {
        public string? Address { get; set; }
        public bool? Gender { get; set; }
        public string? Avatar { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    }
}
