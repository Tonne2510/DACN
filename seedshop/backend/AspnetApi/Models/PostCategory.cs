using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AspnetApi.Models
{
    public class PostCategory
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public bool Active { get; set; }

        public int? ParentId { get; set; }

        [Required]
        [MaxLength(255)]
        public string PostCategoryName { get; set; }

        [MaxLength(255)]
        public string Slug { get; set; }

        [JsonIgnore]
        public ICollection<Post>? Posts { get; set; }

        public DateTime? CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        [MaxLength(100)]
        public string? CreatedBy { get; set; }

        [MaxLength(100)]
        public string? UpdatedBy { get; set; }
        public bool? DeletedAt { get; set; }


    }
}
