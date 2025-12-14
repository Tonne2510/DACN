using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Models
{
    public class RequestApprove
    {
        [Key]
        public int Id { get; set; }

        // Foreign key to the Comment entity
        public int CommentId { get; set; }

        [ForeignKey("CommentId")]
        public Comment Comment { get; set; }

        // Status of the approval request
        [Required]
        [StringLength(20)]
        public string Status { get; set; } = AspnetApi.Constants.Constants.REQUEST_APPROVAL["PENDING"];

        public DateTime RequestedAt { get; set; } = DateTime.UtcNow;

        public DateTime? CreatedAt { get; set; } = DateTime.Now;
    }
}
