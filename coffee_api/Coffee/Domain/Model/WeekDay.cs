﻿using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Model
{
    [Flags]
    public enum WeekDay : int
    {
        Sunday = 1,
        Monday = 2,
        Tuesday = 4,
        Wednesday = 8,
        Thursday = 16,
        Friday = 32,
        Saturday = 64
    }

    public static class WeekDayCombinations
    {
        public const WeekDay WeekDays = WeekDay.Monday | WeekDay.Tuesday | WeekDay.Wednesday | WeekDay.Thursday | WeekDay.Friday;
        public const WeekDay WeekendDays = WeekDay.Saturday | WeekDay.Sunday;
    }
}
