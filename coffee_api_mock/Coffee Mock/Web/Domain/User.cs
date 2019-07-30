using System;
using System.Collections;
using System.Collections.Generic;

namespace Web.Domain
{
    public class User
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string DeliveryAddress { get; set; }
        public virtual ICollection<UserHasFavorite> Favorites { get; set; }
        public virtual ICollection<UserHasStore> Stores { get; set; }
        public virtual ICollection<Request> Requests { get; set; }
    }
}
