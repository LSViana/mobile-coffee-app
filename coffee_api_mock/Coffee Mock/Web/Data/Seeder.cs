using System;
using System.Threading.Tasks;
using Web.Domain;

namespace Web.Data
{
    public class Seeder
    {
        private readonly Db db;
        private Store storeBioBarista;
        private Store storeStarbucks;
        private Category categoryCoffee;
        private Category categoryChoco;
        private Category categorySoda;
        private Product productEspresso;
        private Product productEspressoCinnamon;
        private Product productLatte;
        private Product productRistretto;
        private User userCoffeeDrinker;
        private User userCoffeeSeller;

        public Seeder(Db db)
        {
            this.db = db;
        }

        public async Task Seed()
        {
            await SeedUsers();
            await SeedStores();
            await SeedCategories();
            await SeedProducts();
            await SeedProductInStores();
            await SeedStoreHasCategories();
            await SeedUserHasFavorites();
            await SeedUserHasStores();
            await SeedRequests();
            // Commit changes
            await db.SaveChangesAsync();
        }

        private async Task SeedRequests()
        {
            var request1 = new Request
            {
                Id = Guid.Parse("{17717a9b-9654-4f6c-a479-03facd8feae3}"),
                CreatedAt = DateTime.Now,
                DeliveryAddress = "Alameda Barão de Limeira, 539",
                DeliveryDate = null,
                Store = storeBioBarista,
                Status = RequestStatus.Sent,
                User = userCoffeeDrinker,
                Items = new[] {
                    new RequestItem {
                        Id = Guid.Parse("{bbb534a9-e29e-47d6-865a-b26762d67922}"),
                        Amount = 2,
                        Price = productEspresso.Price,
                        Product = productEspresso,
                    },
                },
            };
            // Adding to database context
            await db.Requests.AddAsync(request1);
        }

        private async Task SeedUserHasStores()
        {
            var userHasStore1 = new UserHasStore
            {
                User = userCoffeeSeller,
                Store = storeBioBarista,
            };
            // Adding to database context
            await db.UserHasStores.AddRangeAsync(userHasStore1);
        }

        private async Task SeedUserHasFavorites()
        {
            var userHasFavorite1 = new UserHasFavorite
            {
                User = userCoffeeDrinker,
                Product = productEspresso,
            };
            // Adding to database context
            await db.UserHasFavorites.AddRangeAsync(userHasFavorite1);
        }

        private async Task SeedStoreHasCategories()
        {
            var storeHasCategory1 = new StoreHasCategory
            {
                Store = storeBioBarista,
                Category = categoryCoffee,
            };
            var storeHasCategory2 = new StoreHasCategory
            {
                Store = storeBioBarista,
                Category = categoryChoco,
            };
            var storeHasCategory3 = new StoreHasCategory
            {
                Store = storeBioBarista,
                Category = categorySoda,
            };
            var storeHasCategory4 = new StoreHasCategory
            {
                Store = storeStarbucks,
                Category = categoryCoffee,
            };
            // Adding to database context
            await db.StoreHasCategories.AddRangeAsync(
                storeHasCategory1,
                storeHasCategory2,
                storeHasCategory3,
                storeHasCategory4
            );
        }

        private async Task SeedCategories()
        {
            categoryCoffee = new Category
            {
                Id = Guid.Parse("{E8403E2A-3CB2-4426-829C-4B2C103FFC0A}"),
                Name = "Coffee",
            };
            categoryChoco = new Category
            {
                Id = Guid.Parse("{E8403E2A-3CB2-4426-829C-4B2C103FFC0B}"),
                Name = "Choco",
            };
            categorySoda = new Category
            {
                Id = Guid.Parse("{E8403E2A-3CB2-4426-829C-4B2C103FFC0C}"),
                Name = "Soda",
            };
            // Adding to database context
            await db.Categories.AddRangeAsync(categoryCoffee, categoryChoco, categorySoda);
        }

        private async Task SeedProductInStores()
        {
            var productInStore1 = new ProductInStore
            {
                Product = productEspresso,
                Store = storeBioBarista,
            };
            var productInStore2 = new ProductInStore
            {
                Product = productEspressoCinnamon,
                Store = storeBioBarista,
            };
            var productInStore3 = new ProductInStore
            {
                Product = productLatte,
                Store = storeBioBarista
            };
            var productInStore4 = new ProductInStore
            {
                Product = productEspresso,
                Store = storeStarbucks,
            };
            var productInStore5 = new ProductInStore
            {
                Product = productRistretto,
                Store = storeBioBarista,
            };
            // Adding to database context
            await db.ProductInStores.AddRangeAsync(
                productInStore1,
                productInStore2,
                productInStore3,
                productInStore4,
                productInStore5
            );
        }

        private async Task SeedProducts()
        {
            productEspresso = new Product
            {
                Id = Guid.Parse("{2D3885EA-8E16-41C2-BF5D-4A76D8CF52A1}"),
                Name = "Espresso",
                Description = "Espresso is coffee of Italian origin, brewed by forcing a small amount of nearly boiling water under pressure through finely ground coffee beans.",
                ImageUrl = "http://www.redegeek.com.br/wp-content/uploads/2015/04/espresso.jpg",
                Price = 6m,
                Category = categoryCoffee,
            };
            productEspressoCinnamon = new Product
            {
                Id = Guid.Parse("{23078e32-572f-4e96-b36b-c0771398ff98}"),
                Name = "Espresso Cinnamon",
                Description = "Espresso mixed with powdered sugar, cinnamon and nutmeg.",
                ImageUrl = "http://cdn.comercialelmar.com.br/produtos/prd_2364/foto.jpg",
                Price = 7m,
                Category = categoryCoffee,
            };
            productLatte = new Product
            {
                Id = Guid.Parse("{5a28bd63-28bc-4a4d-adba-0f4d4c5a38fa}"),
                Name = "Latte",
                Description = "A latte (/ˈlɑːteɪ/ or /ˈlæteɪ/) is a coffee drink made with espresso and steamed milk.",
                ImageUrl = "https://www.nespresso.com/ncp/res/uploads/recipes/nespresso-recipes-Caff%C3%A8-Latte-by-Nespresso.jpg",
                Price = 5m,
                Category = categoryCoffee,
            };
            productRistretto = new Product
            {
                Id = Guid.Parse("{dc105f89-c8a7-4b29-bbf8-6b01df8af4b9}"),
                Name = "Ristretto",
                Description = "A Ristretto is traditionally a short shot of espresso coffee made with the usual amount of finely-ground coffee beans but about half the amount of water normally used when making an espresso.",
                Price = 5m,
                Category = categoryCoffee,
                ImageUrl = "https://d36bl1cjgcfngd.cloudfront.net/wp-content/uploads/sites/2/2018/06/18115512/espresso-sml.jpg",
            };
            // Adding to database context
            await db.Products.AddRangeAsync(
                productEspresso,
                productEspressoCinnamon,
                productLatte,
                productRistretto
            );
        }

        private async Task SeedStores()
        {
            storeBioBarista = new Store
            {
                Id = Guid.Parse("{E5BD162F-2B31-41B6-8259-44C5FB19D403}"),
                Name = "BioBarista",
                OpeningTime = TimeSpan.FromHours(8),
                ClosingTime = TimeSpan.FromHours(22),
                ImageUrl = "https://i.vimeocdn.com/portrait/5308569_300x300",
                WorkingDays = WeekDayCombinations.WeekDays,
            };
            storeStarbucks = new Store
            {
                Id = Guid.Parse("{219bb0d7-6218-483d-8569-ecf80526a2c2}"),
                Name = "Starbucks",
                OpeningTime = TimeSpan.FromHours(6),
                ClosingTime = TimeSpan.FromHours(24),
                ImageUrl = "https://pbs.twimg.com/profile_images/3001407674/8687b5c6bf5880755435f2717b500db0.jpeg",
                WorkingDays = WeekDayCombinations.AllDays,
            };
            // Adding to database context
            await db.Stores.AddRangeAsync(
                storeBioBarista,
                storeStarbucks
            );
        }

        private async Task SeedUsers()
        {
            var standardPassword = "Asdf1234";
            userCoffeeDrinker = new User
            {
                Id = Guid.Parse("{C2D94925-9587-4132-8E63-B69D80315FC3}"),
                Email = "coffee.drinker@email.com",
                Name = "Coffee Drinker",
                DeliveryAddress = "Alameda Barão de Limeira, 539",
                Password = standardPassword,
            };
            userCoffeeSeller = new User
            {
                Id = Guid.Parse("{aaa79141-3c54-492a-b940-ef253868d319}"),
                Email = "coffee.seller@email.com",
                Name = "Coffee Seller",
                DeliveryAddress = "Rua Helvétia, 640",
                Password = standardPassword,
            };
            // Adding to database context
            await db.Users.AddRangeAsync(
                userCoffeeDrinker,
                userCoffeeSeller
            );
        }

    }
}
