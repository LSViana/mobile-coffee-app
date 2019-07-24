using Domain.Model;
using MediatR;
using System;
using System.Collections.Generic;
using System.Text;

namespace Infrastructure.Mediator
{
    public interface IActorAwareRequest<T> : IRequest<T>
    {
        User Actor { get; set; }
    }
}
