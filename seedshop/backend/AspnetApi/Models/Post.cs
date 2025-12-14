using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace AspnetApi.Models
{
    public class Post
    {

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        public string? Description { get; set; }

        [ForeignKey("PostCategory")]
        public int PostCategoryId { get; set; }
        public PostCategory PostCategory { get; set; }

        [Required]
        public string Content { get; set; }

        public string? Status { get; set; }

        public string Slug { get; set; }

        public string? Image { get; set; } 

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? UpdatedAt { get; set; }
        [JsonIgnore]
        public ICollection<Comment>? Comments { get; set; }
    }
}
