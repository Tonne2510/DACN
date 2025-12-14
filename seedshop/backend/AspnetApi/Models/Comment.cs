using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AspnetApi.Models
{
    public class Comment
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [StringLength(500)]
        public string Content { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public int PostId { get; set; }

        [ForeignKey("PostId")]
        public Post? Post { get; set; }

        public string AccountId { get; set; }

        [ForeignKey("AccountId")]
        public Account? Account { get; set; }
        [JsonIgnore]
        public RequestApprove? RequestApprove { get; set; }

    }
}
