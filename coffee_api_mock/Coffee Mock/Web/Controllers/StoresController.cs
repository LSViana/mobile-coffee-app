﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Web.Data;
using Web.Extensions;

namespace Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StoresController : ControllerBase
    {
        private readonly Db db;

        public StoresController(Db db)
        {
            this.db = db;
        }

        [HttpGet]
        public async Task<IActionResult> List()
        {
            var timeOfDay = DateTime.Now.TimeOfDay;
            return Ok(await db.Stores.Select(x => new
            {
                x.Id,
                x.Name,
                x.ImageUrl,
                OpeningTime = x.OpeningTime.WriteHms(),
                ClosingTime = x.ClosingTime.WriteHms(),
                x.WorkingDays,
                Open = x.OpeningTime <= timeOfDay && x.ClosingTime >= timeOfDay,
                Categories = x.Categories.Select(y => new
                {
                    y.Category.Id,
                    y.Category.Name,
                }),
            }).ToArrayAsync());
        }
    }
}