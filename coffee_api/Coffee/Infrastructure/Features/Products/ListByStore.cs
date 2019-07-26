using Data.Context;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Infrastructure.Features.Products
{
    public class ListByStore
    {
        public class Query : IRequest<IEnumerable<Result>>
        {
            public Guid StoreId { get; set; }
        }

        public class CommandValidator : AbstractValidator<Query>
        {
            public CommandValidator()
            {
                RuleFor(x => x.StoreId).NotEmpty();
            }
        }

        public class Result
        {
            public Guid Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string ImageUrl { get; set; }
            public decimal Price { get; set; }
            public Guid CategoryId { get; set; }
        }

        public class RequestHandler : IRequestHandler<Query, IEnumerable<Result>>
        {
            private readonly CoffeeDb db;

            public RequestHandler(CoffeeDb db)
            {
                this.db = db;
            }

            public async Task<IEnumerable<Result>> Handle(Query request, CancellationToken cancellationToken)
            {
                // Fetch the products by store
                var productsQuery = db.Products
                    .Where(x => x.Stores.Any(y => y.StoreId == request.StoreId))
                    .Select(x => new Result
                    {
                        Id = x.Id,
                        Name = x.Name,
                        Description = x.Description,
                        ImageUrl = x.ImageUrl,
                        Price = x.Price,
                        CategoryId = x.CategoryId,
                    });
                // Return the results
                return await Task.FromResult(productsQuery);
            }
        }

    }

}
