﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Web.Domain
{
    public class Store
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string ImageUrl { get; set; }
        public TimeSpan OpeningTime { get; set; }
        public TimeSpan ClosingTime { get; set; }
        public WeekDay WorkingDays { get; set; }
        public virtual ICollection<ProductInStore> Products { get; set; }
        public virtual ICollection<StoreHasCategory> Categories { get; set; }
        public virtual ICollection<UserHasStore> Users { get; set; }
        public virtual ICollection<Request> Requests { get; set; }
    }
}
