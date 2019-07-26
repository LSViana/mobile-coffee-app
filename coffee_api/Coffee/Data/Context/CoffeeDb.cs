using Domain.Model;
using Microsoft.EntityFrameworkCore;

namespace Data.Context
{
    public class CoffeeDb : DbContext
    {
        public CoffeeDb(DbContextOptions<CoffeeDb> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Store> Stores { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<ProductInStore> ProductInStores { get; set; }
        public DbSet<StoreHasCategory> StoreHasCategories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            #region User
            modelBuilder.Entity<User>()
                .Property(x => x.Email)
                .HasMaxLength(48)
                .IsRequired();
            modelBuilder.Entity<User>()
                .Property(x => x.Name)
                .HasMaxLength(48)
                .IsRequired();
            modelBuilder.Entity<User>()
                .Property(x => x.PasswordHash)
                .IsRequired();
            modelBuilder.Entity<User>()
                .Property(x => x.PasswordSalt)
                .IsRequired();
            modelBuilder.Entity<User>()
                .Property(x => x.DeliveryAddress)
                .IsRequired()
                .HasMaxLength(256);
            #endregion
            #region Product
            modelBuilder.Entity<Product>()
                .Property(x => x.Name)
                .IsRequired()
                .HasMaxLength(48);
            modelBuilder.Entity<Product>()
                .Property(x => x.Description)
                .IsRequired()
                .HasMaxLength(512);
            modelBuilder.Entity<Product>()
                .Property(x => x.ImageUrl)
                .IsRequired()
                .HasMaxLength(256);
            modelBuilder.Entity<Product>()
                .Property(x => x.Price)
                .IsRequired();
            modelBuilder.Entity<Product>()
                .HasOne(x => x.Category)
                .WithMany(x => x.Products);
            #endregion
            #region Store
            modelBuilder.Entity<Store>()
                .Property(x => x.Name)
                .IsRequired()
                .HasMaxLength(48);
            modelBuilder.Entity<Store>()
                .Property(x => x.ImageUrl)
                .IsRequired()
                .HasMaxLength(256);
            modelBuilder.Entity<Store>()
                .Property(x => x.OpeningTime)
                .IsRequired();
            modelBuilder.Entity<Store>()
                .Property(x => x.ClosingTime)
                .IsRequired();
            modelBuilder.Entity<Store>()
                .Property(x => x.WorkingDays)
                .IsRequired();
            #endregion
            #region ProductInStore
            modelBuilder.Entity<ProductInStore>()
                .HasKey(x => new
                {
                    x.ProductId,
                    x.StoreId,
                });
            modelBuilder.Entity<ProductInStore>()
                .HasOne(x => x.Product)
                .WithMany(x => x.Stores);
            modelBuilder.Entity<ProductInStore>()
                .HasOne(x => x.Store)
                .WithMany(x => x.Products);
            #endregion
            #region Category
            modelBuilder.Entity<Category>()
                .Property(x => x.Name)
                .IsRequired();
            modelBuilder.Entity<Category>()
                .HasMany(x => x.Products)
                .WithOne(x => x.Category);
            #endregion
            #region StoreHasCategory
            modelBuilder.Entity<StoreHasCategory>()
                .HasKey(x => new
                {
                    x.CategoryId,
                    x.StoreId
                });
            #endregion
        }
    }
}
