using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Microsoft.TeamFoundation.Common;
using myapi.Services;
using myshared.DTOs;
using myshared.Models;
using myshared.Services;
using static myapi.Services.AzureService;

namespace myapi.Controllers // controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExampleModelController : ControllerBase
    {
        private readonly ExampleModelService _exampleModelService;
		private readonly ExampleNavigationPropertyService _exampleNavigationPropertyService;
		private readonly AzureService _azureService;

		public ExampleModelController(ExampleModelService exampleService, 
			ExampleNavigationPropertyService exampleNavPropService,
			AzureService azureService)
        {
            _exampleModelService = exampleService;
			_exampleNavigationPropertyService = exampleNavPropService;
			_azureService = azureService;
		}

        // GET: api/ExampleModel
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ExampleDTO>>> GetAllAsync()
        {
            var examples = await _exampleModelService.GetAllAsync();

			if (examples is null) return BadRequest();
			if (examples.Count() < 1) return NotFound();

			return Ok(examples);

		}

		// GET: api/ExampleNavigationProperty
		[HttpGet("ExampleNavigationProperty")]
		public async Task<ActionResult<IEnumerable<ExampleDTO>>> GetAllNavPropsAsync()
		{
			var examples = await _exampleNavigationPropertyService.GetAllAsync();

			if (examples is null) return BadRequest();
			if (examples.Count() < 1) return NotFound();

			return Ok(examples);

		}

		// GET: api/ExampleNavigationProperty
		[HttpGet("GetResources")]
		public ActionResult<List<AzureResource>> GetAllResources()
		{
			var resources = _azureService.GetResourcesList();

			if (resources is null) return BadRequest();
			if (resources.Count() < 1) return NotFound();

			return Ok(resources);
		}

		// GET: api/ExampleModel/5
		[HttpGet("{id}")]
        public async Task<ActionResult<ExampleDTO>> GetByIdAsync(string id)
        {
            var example = await _exampleModelService.GetByIdAsync(id);

			if (example is null) return BadRequest();
			if (example.Title.IsNullOrEmpty()) return NotFound();

			return Ok(example);
        }

		// POST: api/ExampleModel
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<ExampleDTO>> AddAsync(ExampleDTO exampleDTO)
		{
			var example = await _exampleModelService.AddAsync(exampleDTO);

			if (example is null) return BadRequest();
			if (example.Title.IsNullOrEmpty()) return NotFound();

			return CreatedAtAction("GetExampleModel", new { id = exampleDTO.Id }, exampleDTO);
		}

		// PUT: api/ExampleModel/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
        public async Task<IActionResult> UpdateAsync(string id, ExampleDTO exampleDTO)
        {
            var example = await _exampleModelService.UpdateAsync(id, exampleDTO);

			if (example is null) return BadRequest();
			if (example.Title.IsNullOrEmpty()) return NotFound();

			return NoContent();
        }

		// DELETE: api/ExampleModel/5
		[HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAsync(string id)
        {
            var example = await _exampleModelService.DeleteAsync(id);

			if (example is null) return BadRequest();
			if (example.Title.IsNullOrEmpty()) return NotFound();

			return NoContent();
        }
    }
}
