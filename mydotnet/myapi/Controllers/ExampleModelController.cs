using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Microsoft.TeamFoundation.Common;
using myapi.Services;
using myapi.Utility;
using myshared.DTOs;
using myshared.Models;
using myshared.Services;
using static myapi.Utility.AzureUtility;

namespace myapi.Controllers // controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExampleModelController : ControllerBase
    {
        private readonly ExampleModelService _exampleModelService;
		private readonly ExampleNavigationPropertyService _exampleNavigationPropertyService;
		private readonly AzureUtility _azureUtility;

		public ExampleModelController(ExampleModelService exampleService, 
			ExampleNavigationPropertyService exampleNavPropService,
			AzureUtility azureUtility)
        {
            _exampleModelService = exampleService;
			_exampleNavigationPropertyService = exampleNavPropService;
			_azureUtility = azureUtility;
		}

        // GET: api/ExampleModel
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ExampleDTO>>> GetAllAsync()
        {
            var examples = await _exampleModelService.GetAllAsync();

			if (examples.IsNullOrEmpty()) return NotFound();

			return Ok(examples);

		}

		// GET: api/ExampleNavigationProperty
		[HttpGet("ExampleNavigationProperty")]
		public async Task<ActionResult<IEnumerable<ExampleDTO>>> GetAllNavPropsAsync()
		{
			var examples = await _exampleNavigationPropertyService.GetAllAsync();

			if (examples.IsNullOrEmpty()) return NotFound();

			return Ok(examples);

		}

		// GET: api/ExampleNavigationProperty
		[HttpGet("GetResources")]
		public ActionResult<List<AzureResource>> GetAllResources()
		{
			var resources = _azureUtility.GetResourcesList();

			if (resources.IsNullOrEmpty()) return NotFound();

			return Ok(resources);
		}

		// GET: api/ExampleModel/5
		[HttpGet("{id}")]
        public async Task<ActionResult<ExampleDTO>> GetByIdAsync(string id)
		{
			if (id is null) return BadRequest();

			var example = await _exampleModelService.GetByIdAsync(id);

			if (example is null) return NotFound();

			return Ok(example);
        }

		// POST: api/ExampleModel
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPost]
		public async Task<ActionResult<ExampleDTO>> AddAsync(ExampleDTO exampleDTO)
		{
			if (exampleDTO is null) return BadRequest();

			var example = await _exampleModelService.AddAsync(exampleDTO);

			if (example is null) return NotFound();

			return CreatedAtAction(nameof(GetByIdAsync), new { id = exampleDTO.Id }, exampleDTO);
		}

		// PUT: api/ExampleModel/5
		// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
		[HttpPut("{id}")]
        public async Task<IActionResult> UpdateAsync(string id, ExampleDTO exampleDTO)
		{
			if (id is null || exampleDTO is null) return BadRequest();

			var example = await _exampleModelService.GetByIdAsync(id);

			if (example is null) return NotFound();

			await _exampleModelService.UpdateAsync(id, exampleDTO);

			return NoContent();
        }

		// DELETE: api/ExampleModel/5
		[HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAsync(string id)
        {
			if (id is null) return BadRequest();

			var example = await _exampleModelService.GetByIdAsync(id);

			if (example is null) return NotFound();

			await _exampleModelService.DeleteAsync(id);

			return NoContent();
        }
    }
}
