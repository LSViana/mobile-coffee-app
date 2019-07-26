using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Model
{
    public class Category
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public virtual ICollection<StoreHasCategory> Stores { get; set; }
        public virtual ICollection<Product> Products { get; set; }
    }
}
