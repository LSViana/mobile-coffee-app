using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Web.Domain;

namespace Web.Data
{
    public class Db : DbContext
    {
        public Db(DbContextOptions<Db> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Store> Stores { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<UserHasFavorite> UserHasFavorites { get; set; }
        public DbSet<ProductInStore> ProductInStores { get; set; }
        public DbSet<StoreHasCategory> StoreHasCategories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            #region StoreHasCategories
            modelBuilder.Entity<StoreHasCategory>()
                .HasKey(x => new
                {
                    x.CategoryId,
                    x.StoreId,
                });
            #endregion
            #region ProductInStore
            modelBuilder.Entity<ProductInStore>()
                .HasKey(x => new
                {
                    x.ProductId,
                    x.StoreId,
                });
            #endregion
            #region UserHasFavorite
            modelBuilder.Entity<UserHasFavorite>()
                .HasKey(x => new
                {
                    x.UserId,
                    x.ProductId,
                });
            #endregion
        }
    }
}
