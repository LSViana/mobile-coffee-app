﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Web.Domain;

namespace Web.Data
{
    public class Seeder
    {
        private readonly Db db;
        private Store storeBioBarista;
        private Category categoryCoffee;
        private Category categoryChoco;
        private Category categorySoda;
        private Product productEspresso;
        private Product productEspressoCinnamon;
        private Product productLatte;
        private User userCoffeeDrinker;

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
            await SeedUserHasFavorite();
            // Commit changes
            await db.SaveChangesAsync();
        }

        private async Task SeedUserHasFavorite()
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
            // Adding to database context
            await db.StoreHasCategories.AddRangeAsync(storeHasCategory1, storeHasCategory2, storeHasCategory3);
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
            // Adding to database context
            await db.ProductInStores.AddRangeAsync(
                productInStore1,
                productInStore2,
                productInStore3
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
            // Adding to database context
            await db.Products.AddRangeAsync(
                productEspresso,
                productEspressoCinnamon,
                productLatte
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
            // Adding to database context
            await db.Stores.AddRangeAsync(storeBioBarista);
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
            // Adding to database context
            await db.Users.AddRangeAsync(userCoffeeDrinker);
        }

    }
}