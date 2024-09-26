using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using myapi.Data;
using myapi.Repositories;
using myapi.Services;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Controllers // controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExampleModelsController : ControllerBase
    {
        private readonly DataContext _context;
		private readonly NosqlExampleModelsRepository _nosqlcontext;
        private readonly ExampleService _exampleService;

		public ExampleModelsController(DataContext context, NosqlExampleModelsRepository nosqlExampleRepository, ExampleService exampleService)
        {
            _context = context;
            _nosqlcontext = nosqlExampleRepository;
            _exampleService = exampleService;
		}

        // GET: api/PortfolioProjects
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ExampleDTO>>> GetAllAsync()
        {
            //var exampleModels = await _context.ExampleModels.ToListAsync();
            //var exampleModels = await _nosqlcontext.GetAllAsync();
            //var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x));

            var examples = await _exampleService.GetAllAsync();

            if (examples.IsNullOrEmpty()) return BadRequest();

			return Ok(examples);

		}

        // GET: api/PortfolioProjects/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ExampleDTO>> GetByIdAsync(int id)
        {
            //var exampleModel = await _context.ExampleModels.FindAsync(id);
			//var exampleModel = await _nosqlcontext.GetByIdAsync(id);

			//if (exampleModel == null)
   //         {
   //             return NotFound();
			//}

			//var exampleDTO = new ExampleDTO(exampleModel);

            var example = await _exampleService.GetByIdAsync(id);

			if (example is null) return NotFound();

			return Ok(example);
        }

        // PUT: api/PortfolioProjects/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAsync(int id, ExampleDTO exampleDTO)
        {
			if (id != exampleDTO.Id) return BadRequest();

			//var exampleModel = await _context.ExampleModels.FindAsync(id);
			//var exampleModel = await _nosqlcontext.GetByIdAsync(id);
			//exampleModel.Id = exampleDTO.Id;
			//exampleModel.Title = exampleDTO.Title;
			//exampleModel.Description = exampleDTO.Description;

			//_context.Entry(exampleModel).State = EntityState.Modified;

            // incomment if using mssql, not nosql
            //try
            //{
            //    await _context.SaveChangesAsync();
            //}
            //catch (DbUpdateConcurrencyException)
            //{
            //    if (!ExampleModelExists(id))
            //    {
            //        return NotFound();
            //    }
            //    else
            //    {
            //        throw;
            //    }
            //}

            var example = await _exampleService.UpdateAsync(id, exampleDTO);

			if (example == null) return BadRequest();

			return NoContent();
        }

        // POST: api/PortfolioProjects
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<MssqlExampleModel>> AddAsync(ExampleDTO exampleDTO)
        {
            //var exampleModel = new NosqlExampleModel(exampleDTO);
            //_nosqlcontext.AddAsync(exampleModel);
            // await _context.SaveChangesAsync(); // incomment if using mssql, not nosql

            var example = await _exampleService.AddAsync(exampleDTO);

			if (example == null) return BadRequest();

			return CreatedAtAction("GetExampleModel", new { id = exampleDTO.Id }, exampleDTO);
        }

        // DELETE: api/PortfolioProjects/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAsync(int id)
        {
            //var exampleModel = await _context.ExampleModels.FindAsync(id);
            //if (exampleModel == null)
            //{
            //    return NotFound();
            //}

            //_context.ExampleModels.Remove(exampleModel);
            //await _context.SaveChangesAsync();

            var example = await _exampleService.DeleteAsync(id);

			if (example == null) return BadRequest();

			return NoContent();
        }
    }
}
