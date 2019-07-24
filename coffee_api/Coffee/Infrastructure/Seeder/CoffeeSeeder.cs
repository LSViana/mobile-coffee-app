using Data.Context;
using Domain.Model;
using Infrastructure.ConfigurationModels;
using Infrastructure.Security;
using System;
using System.Threading.Tasks;

namespace Infrastructure.Seeder
{
    public class CoffeeSeeder
    {
        private readonly SeederConfigurationData seederData;
        private readonly CoffeeDb db;

        public CoffeeSeeder(SeederConfigurationData seederData, CoffeeDb db)
        {
            this.seederData = seederData;
            this.db = db;
        }

        public async Task Seed()
        {
            await SeedUsers();
            // Commit changes
            await db.SaveChangesAsync();
        }

        private async Task SeedUsers()
        {
            var standardPassword = seederData.DefaultPassword;
            var standardSalt = seederData.DefaultSaltGuid.ToByteArray();
            var standardHash = CoffeeHasher.HashWithSalt(standardPassword, standardSalt);
            var user1 = new User
            {
                Id = Guid.Parse("{C2D94925-9587-4132-8E63-B69D80315FC3}"),
                Email = "coffee.drinker@email.com",
                Name = "Coffee Drinker",
                PasswordHash = standardHash,
                PasswordSalt = standardSalt,
                // Metadata
                CreatedAt = DateTime.Now,
            };
            // Adding to database context
            await db.Users.AddRangeAsync(user1);
        }
    }
}
