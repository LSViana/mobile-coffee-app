using Domain.Definitions;
using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Model
{
    public class User : IDomain
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string DeliveryAddress { get; set; }
        public byte[] PasswordSalt { get; set; }
        public byte[] PasswordHash { get; set; }
        public DateTime? DeletedAt { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
