using Data.Context;
using Domain.Model;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Infrastructure.Features.Stores
{
    public class List
    {
        public class Query : IRequest<IEnumerable<Result>>
        {
        }

        public class Result
        {
            public Guid Id { get; set; }
            public string Name { get; set; }
            public bool Open { get; set; }
            public string ImageUrl { get; set; }
            public WeekDay WorkingDays { get; set; }
            public TimeSpan OpeningTime { get; set; }
            public TimeSpan ClosingTime { get; set; }
            public IEnumerable<CategoryResult> Categories { get; set; }
            public class CategoryResult
            {
                public Guid Id { get; set; }
                public string Name { get; set; }
            }
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
                var timeOfDay = DateTime.Now.ToLocalTime().TimeOfDay;
                // Get the stores with the open/closed status
                var storesQuery = db.Stores
                    .Select(x => new Result
                    {
                        Id = x.Id,
                        Name = x.Name,
                        ImageUrl = x.ImageUrl,
                        OpeningTime = x.OpeningTime,
                        ClosingTime = x.ClosingTime,
                        WorkingDays = x.WorkingDays,
                        Open = x.OpeningTime <= timeOfDay && x.ClosingTime >= timeOfDay,
                        Categories = x.Categories
                            .Select(y => y.Category)
                            .Select(y => new Result.CategoryResult
                            {
                                Id = y.Id,
                                Name = y.Name,
                            }),
                    });
                // Return the result
                return await Task.FromResult(storesQuery);
            }
        }

    }

}
