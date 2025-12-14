using AspnetApi.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace AspnetApi.Data
{
    public class ApiDbContext: IdentityDbContext<Account>
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> opt) : base(opt)
        {

        }

        public virtual DbSet<RefreshToken> RefreshTokens { get; set; }
        public virtual DbSet<Category> Categories { get; set; }
        public virtual DbSet<AttributeC> Attributes { get; set; }
        public virtual DbSet<AttributeOption> AttributeOptions { get; set; }
        public virtual DbSet<Product> Products { get; set; }
        public virtual DbSet<AttributeOptionProduct> AttributeOptionProducts { get; set; }
        public virtual DbSet<Cart> Carts { get; set; }
        public virtual DbSet<CartItem> CartItems { get; set; }
        public virtual DbSet<Order> Order { get; set; }
        public virtual DbSet<OrderItem> OrderItems { get; set; }
        public virtual DbSet<PostCategory> PostCategories { get; set; }
        public virtual DbSet<Post> Posts { get; set; }
        public virtual DbSet<Comment> Comments { get; set; }
        public virtual DbSet<RequestApprove> RequestApproves { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Configure CartItem entity
            modelBuilder.Entity<CartItem>()
                .HasOne(ci => ci.Cart) 
                .WithMany(c => c.CartItems) 
                .HasForeignKey(ci => ci.CartId) 
                .OnDelete(DeleteBehavior.Cascade); 

            modelBuilder.Entity<OrderItem>()
              .HasOne(ci => ci.Order) 
              .WithMany(c => c.OrderItems) 
              .HasForeignKey(ci => ci.OrderId) 
              .OnDelete(DeleteBehavior.Cascade); 

            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<RequestApprove>()
           .HasOne(r => r.Comment)
           .WithOne(c => c.RequestApprove)
            .HasForeignKey<RequestApprove>(r => r.CommentId)
           .OnDelete(DeleteBehavior.Cascade);

        }
    }
}
