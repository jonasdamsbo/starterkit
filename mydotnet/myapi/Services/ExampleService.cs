using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using myapi.Data;
using myapi.Repositories;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Services
{
	public class ExampleService
	{
		/*private NosqlExampleModelRepository _nosqlrepo;
		private MssqlExampleModelRepository _mssqlrepo;*/
		private IRepository _context;

		public ExampleService(ExampleModelRepository exampleRepository/*, NosqlExampleModelRepository nosqlExampleRepository, MssqlExampleModelRepository mssqlExampleRepository*/)
		{
			/*_nosqlrepo = nosqlExampleRepository;
			_mssqlrepo = mssqlExampleRepository;*/
			_context = exampleRepository;
		}

		public async Task<List<ExampleDTO>> GetAllAsync()
		{
			var exampleModels = await _context.GetAllAsync();

			if (exampleModels.IsNullOrEmpty()) return new List<ExampleDTO>();
			
			var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();
			return exampleDTOs;

			//var exampleModels = await _context.ExampleModels.ToListAsync();
		}

		public async Task<ExampleDTO?> GetByIdAsync(string id)
		{
			var exampleModel = await _context.GetByIdAsync(id);

			if(exampleModel == null) return null;

			return new ExampleDTO(exampleModel);


			//var exampleModel = await _context.ExampleModels.FindAsync(id);
			//if (exampleModel == null)
			//{
			//	return null;
			//}
		}

		public async Task<ExampleDTO> AddAsync(ExampleDTO exampleDTO)
		{
			var exampleModel = new ExampleModel(exampleDTO);
			exampleModel = await _context.AddAsync(exampleModel);

			if(exampleModel == null) return null;
			return new ExampleDTO(exampleModel);


			/*var portfolioProjectDTO = new PortfolioProjectDTO
			{
				Title = portfolioProjectDTO.Title,
				Description = portfolioProjectDTO.Description
			};*/
			//throw;

			//portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);
		}

		public async Task<ExampleDTO?> UpdateAsync(string id, ExampleDTO updatedExampleDTO)
		{
			var updatedExampleModel = new ExampleModel(updatedExampleDTO);
			updatedExampleModel = await _context.UpdateAsync(id, updatedExampleModel);

			if(updatedExampleModel == null) return null;
			return new ExampleDTO(updatedExampleModel);


			//throw;

			//if (exampleModel is null) return null;
		}

		public async Task<ExampleDTO?> DeleteAsync(string id)
		{
			var exampleModel = await _context.DeleteAsync(id);

			if(exampleModel == null) return null;
			return new ExampleDTO(exampleModel);


			//throw;
			//var exampleModel = await _nosqlrepo.GetByIdAsync(id);

			//if (exampleModel is NosqlExampleModel)
			//{
			//	await _nosqlrepo.DeleteAsync(id);
			//	return new ExampleDTO(exampleModel);
			//}
			//
			//return null;
		}
	}
}
