using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Controllers // controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PortfolioProjectsController : ControllerBase
    {
        private readonly DataContext _context;

        public PortfolioProjectsController(DataContext context)
        {
            _context = context;
        }

        // GET: api/PortfolioProjects
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PortfolioProjectDTO>>> GetPortfolioProjects()
        {
            var portfolioprojects = await _context.PortfolioProjects.ToListAsync();
            var portfolioprojectDTOs = portfolioprojects.Select(x => new PortfolioProjectDTO(x));

			return Ok(portfolioprojectDTOs);

		}

        // GET: api/PortfolioProjects/5
        [HttpGet("{id}")]
        public async Task<ActionResult<PortfolioProjectDTO>> GetPortfolioProject(int id)
        {
            var portfolioProject = await _context.PortfolioProjects.FindAsync(id);

			if (portfolioProject == null)
            {
                return NotFound();
			}

			var portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);

			return Ok(portfolioProjectDTO);
        }

        // PUT: api/PortfolioProjects/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPortfolioProject(int id, PortfolioProjectDTO portfolioProjectDTO)
        {
			if (id != portfolioProjectDTO.Id)
            {
                return BadRequest();
            }

			var portfolioProject = await _context.PortfolioProjects.FindAsync(id);
			portfolioProject.Id = portfolioProjectDTO.Id;
			portfolioProject.Title = portfolioProjectDTO.Title;
			portfolioProject.Description = portfolioProjectDTO.Description;

			_context.Entry(portfolioProject).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PortfolioProjectExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/PortfolioProjects
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<PortfolioProject>> PostPortfolioProject(PortfolioProject portfolioProject)
        {
            _context.PortfolioProjects.Add(portfolioProject);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPortfolioProject", new { id = portfolioProject.Id }, portfolioProject);
        }

        // DELETE: api/PortfolioProjects/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePortfolioProject(int id)
        {
            var portfolioProject = await _context.PortfolioProjects.FindAsync(id);
            if (portfolioProject == null)
            {
                return NotFound();
            }

            _context.PortfolioProjects.Remove(portfolioProject);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool PortfolioProjectExists(int id)
        {
            return _context.PortfolioProjects.Any(e => e.Id == id);
        }
    }
}
