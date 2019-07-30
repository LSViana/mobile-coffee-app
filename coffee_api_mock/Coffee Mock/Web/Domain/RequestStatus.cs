using System;
namespace Web.Domain
{
    public enum RequestStatus
    {
        Sent = 0,
        Preparing = 1,
        Ready = 2,
        Delivering = 3,
        Delivered = 4,
    }
}
