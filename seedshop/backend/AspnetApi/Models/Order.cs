using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace AspnetApi.Models
{
    public class Order
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Account")]
        public string UserId { get; set; }

        public Account? Account { get; set; }

        public DateTime? OrderDate { get; set; } = DateTime.Now;

        public string Status { get; set; }

        public string ShippingAddress { get; set; }

        public float TotalAmount { get; set; }

        public ICollection<OrderItem>? OrderItems { get; set; }

        public DateTime? CreatedAt { get; set; } = DateTime.Now;
        public DateTime? UpdatedAt { get; set; }
    }
}
