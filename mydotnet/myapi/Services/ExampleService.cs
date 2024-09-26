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
		private readonly NosqlExampleModelsRepository _nosqlrepo;
		private readonly MssqlExampleModelsRepository _mssqlrepo;

		public ExampleService(NosqlExampleModelsRepository nosqlExampleRepository, MssqlExampleModelsRepository mssqlExampleRepository)
		{
			_nosqlrepo = nosqlExampleRepository;
			_mssqlrepo = mssqlExampleRepository;
		}

		public async Task<List<ExampleDTO>> GetAllAsync()
		{
			//var exampleModels = await _context.ExampleModels.ToListAsync();
			var exampleModels = await _nosqlrepo.GetAllAsync();

			if (exampleModels.IsNullOrEmpty()) return new List<ExampleDTO>();
			
			var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();
			return exampleDTOs;
			
		}

		public async Task<ExampleDTO?> GetByIdAsync(int id)
		{
			//var exampleModel = await _context.ExampleModels.FindAsync(id);
			var exampleModel = await _nosqlrepo.GetByIdAsync(id);

			if(exampleModel == null) return null;

			return new ExampleDTO(exampleModel);

			//if (exampleModel == null)
			//{
			//	return null;
			//}
		}

		public async Task<ExampleDTO> AddAsync(ExampleDTO exampleDTO)
		{
			/*var portfolioProjectDTO = new PortfolioProjectDTO
			{
				Title = portfolioProjectDTO.Title,
				Description = portfolioProjectDTO.Description
			};*/

			var exampleModel = new NosqlExampleModel(exampleDTO);
			exampleModel = await _nosqlrepo.AddAsync(exampleModel);

			if(exampleModel == null) return null;
				//throw;
			return new ExampleDTO(exampleModel);

			//portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);

		}

		public async Task<ExampleDTO?> UpdateAsync(int id, ExampleDTO updatedExampleDTO)
		{
			var updatedExampleModel = new NosqlExampleModel(updatedExampleDTO);
			updatedExampleModel = await _nosqlrepo.UpdateAsync(id, updatedExampleModel);

			if(updatedExampleModel == null) return null;
				//throw;
			return new ExampleDTO(updatedExampleModel);

			//if (exampleModel is null) return null;
		}

		public async Task<ExampleDTO?> DeleteAsync(int id)
		{
			var exampleModel = await _nosqlrepo.DeleteAsync(id);

			if(exampleModel == null) return null;
				//throw;
				//var exampleModel = await _nosqlrepo.GetByIdAsync(id);
			return new ExampleDTO(exampleModel);

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
