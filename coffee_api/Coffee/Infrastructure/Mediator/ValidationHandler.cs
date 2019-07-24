using FluentValidation;
using Infrastructure.Exceptions;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Infrastructure.Security
{
    public class ValidationHandler<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    {
        private readonly IEnumerable<IValidator<TRequest>> validators;

        public ValidationHandler(IEnumerable<IValidator<TRequest>> validators)
        {
            this.validators = validators;
        }

        public async Task<TResponse> Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate<TResponse> next)
        {
            var failedValidations = validators
                .Select(x => x.Validate(request))
                .Where(x => !x.IsValid)
                .ToArray();

            if (failedValidations.Any())
            {
                var errors = failedValidations.SelectMany(x => x.Errors.Select(y => new ValidationResult()
                {
                    Error = y.ErrorMessage,
                    Property = y.PropertyName,
                    Value = y.AttemptedValue,
                }))
                .Distinct()
                .ToArray();
                throw new BadRequestException(errors);
            }

            return await next();
        }
    }

    public struct ValidationResult
    {
        public string Property { get; set; }
        public string Error { get; set; }
        public object Value { get; set; }
    }
}
