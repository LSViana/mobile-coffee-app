using Domain.Model;
using Microsoft.EntityFrameworkCore;

namespace Data.Context
{
    public class CoffeeDb : DbContext
    {
        public CoffeeDb(DbContextOptions<CoffeeDb> options) : base(options) { }

        public DbSet<User> Users { get; set; }
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
            #endregion
        }
    }
}
