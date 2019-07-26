using Data.Context;
using Domain.Model;
using Infrastructure.ConfigurationModels;
using Infrastructure.Security;
using System;
using System.Linq;
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
            // Don't change the order of the calls
            await SeedUsers();
            await SeedStores();
            await SeedCategories();
            await SeedProducts();
            await SeedProductInStores();
            await SeedStoreHasCategories();
            // Commit changes
            await db.SaveChangesAsync();
        }

        private async Task SeedStoreHasCategories()
        {
            var storeHasCategory1 = new StoreHasCategory
            {
                Store = db.Stores.Local.ElementAt(0),
                Category = db.Categories.Local.ElementAt(0),
            };
            var storeHasCategory2 = new StoreHasCategory
            {
                Store = db.Stores.Local.ElementAt(0),
                Category = db.Categories.Local.ElementAt(1),
            };
            var storeHasCategory3 = new StoreHasCategory
            {
                Store = db.Stores.Local.ElementAt(0),
                Category = db.Categories.Local.ElementAt(2),
            };
            // Adding to database context
            await db.StoreHasCategories.AddRangeAsync(storeHasCategory1, storeHasCategory2, storeHasCategory3);
        }

        private async Task SeedCategories()
        {
            var category1 = new Category
            {
                Id = Guid.Parse("{E8403E2A-3CB2-4426-829C-4B2C103FFC0A}"),
                Name = "Coffee",
            };
            var category2 = new Category
            {
                Id = Guid.Parse("{E8403E2A-3CB2-4426-829C-4B2C103FFC0B}"),
                Name = "Choco",
            };
            var category3 = new Category
            {
                Id = Guid.Parse("{E8403E2A-3CB2-4426-829C-4B2C103FFC0C}"),
                Name = "Soda",
            };
            // Adding to database context
            await db.Categories.AddRangeAsync(category1, category2, category3);
        }

        private async Task SeedProductInStores()
        {
            var productInStore1 = new ProductInStore
            {
                Product = db.Products.Local.ElementAt(0),
                Store = db.Stores.Local.ElementAt(0),
            };
            // Adding to database context
            await db.ProductInStores.AddRangeAsync(productInStore1);
        }

        private async Task SeedProducts()
        {
            var product1 = new Product
            {
                Id = Guid.Parse("{2D3885EA-8E16-41C2-BF5D-4A76D8CF52A1}"),
                Name = "Espresso",
                Description = "Espresso is coffee of Italian origin, brewed by forcing a small amount of nearly boiling water under pressure through finely ground coffee beans.",
                ImageUrl = "http://www.redegeek.com.br/wp-content/uploads/2015/04/espresso.jpg",
                Price = 6m,
                Category = db.Categories.Local.ElementAt(0),
            };
            // Adding to database context
            await db.Products.AddRangeAsync(product1);
        }

        private async Task SeedStores()
        {
            var store1 = new Store
            {
                Id = Guid.Parse("{E5BD162F-2B31-41B6-8259-44C5FB19D403}"),
                Name = "BioBarista",
                OpeningTime = TimeSpan.FromHours(8),
                ClosingTime = TimeSpan.FromHours(22),
                ImageUrl = "https://i.vimeocdn.com/portrait/5308569_300x300",
                WorkingDays = WeekDayCombinations.WeekDays,
            };
            // Adding to database context
            await db.Stores.AddRangeAsync(store1);
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
                DeliveryAddress = "Alameda Barão de Limeira, 539",
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
