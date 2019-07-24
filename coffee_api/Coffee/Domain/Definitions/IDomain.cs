using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Definitions
{
    public interface IDomain
    {
        DateTime? DeletedAt { get; set; }
        DateTime CreatedAt { get; set; }
    }
}
