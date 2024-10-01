﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using myapi.Services;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Controllers // controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExampleModelController : ControllerBase
    {
        private readonly ExampleService _exampleService;
		private readonly ExampleNavPropService _exampleNavPropService;

		public ExampleModelController(ExampleService exampleService, ExampleNavPropService exampleNavPropService)
        {
            _exampleService = exampleService;
			_exampleNavPropService = exampleNavPropService;
		}

        // GET: api/ExampleModel
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ExampleDTO>>> GetAllAsync()
        {
            var examples = await _exampleService.GetAllAsync();

			if (examples == new List<ExampleDTO>()) return NotFound();
			if (examples is null) return BadRequest();

			return Ok(examples);

		}

		// GET: api/ExampleModel
		[HttpGet("ExampleNavigationProperty")]
		public async Task<ActionResult<IEnumerable<ExampleDTO>>> GetAllNavPropsAsync()
		{
			var examples = await _exampleNavPropService.GetAllAsync();

			if (examples == new List<ExampleNavigationProperty>()) return NotFound();
			if (examples is null) return BadRequest();

			return Ok(examples);

		}

		// GET: api/ExampleModel/5
		[HttpGet("{id}")]
        public async Task<ActionResult<ExampleDTO>> GetByIdAsync(string id)
        {
            var example = await _exampleService.GetByIdAsync(id);

			if (example == new ExampleDTO()) return NotFound();
			if (example is null) return BadRequest();

			return Ok(example);
        }

		// POST: api/ExampleModel
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<ExampleDTO>> AddAsync(ExampleDTO exampleDTO)
		{
			var example = await _exampleService.AddAsync(exampleDTO);

			if (example == new ExampleDTO()) return NotFound();
			if (example is null) return BadRequest();

			return CreatedAtAction("GetExampleModel", new { id = exampleDTO.Id }, exampleDTO);
		}

		// PUT: api/ExampleModel/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
        public async Task<IActionResult> UpdateAsync(string id, ExampleDTO exampleDTO)
        {
            var example = await _exampleService.UpdateAsync(id, exampleDTO);

			if (example == new ExampleDTO()) return NotFound();
			if (example is null) return BadRequest();

			return NoContent();
        }

		// DELETE: api/ExampleModel/5
		[HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAsync(string id)
        {
            var example = await _exampleService.DeleteAsync(id);

			if (example == new ExampleDTO()) return NotFound();
			if (example is null) return BadRequest();

			return NoContent();
        }
    }
}
