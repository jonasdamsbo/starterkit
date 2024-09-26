using Microsoft.AspNetCore.Mvc;
using myapi.Data;
using myapi.Repositories;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Services
{
	public class ExampleService
	{
		private readonly DataContext _context;
		private readonly NosqlExampleModelsRepository _nosqlrepo;
		private readonly MssqlExampleModelsRepository _mssqlrepo;

		public ExampleService(DataContext context, NosqlExampleModelsRepository nosqlExampleRepository, MssqlExampleModelsRepository mssqlExampleRepository)
		{
			_context = context;
			_nosqlrepo = nosqlExampleRepository;
			_mssqlrepo = mssqlExampleRepository;
		}

		public async Task<List<ExampleDTO>> GetAllAsync()
		{
			//var exampleModels = await _context.ExampleModels.ToListAsync();

			try
			{
				var exampleModels = await _nosqlrepo.GetAllAsync();
				var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();

				return exampleDTOs;
			}
			catch (Exception ex) 
			{ 
				return new List<ExampleDTO>();
			}
			
		}

		public async Task<ExampleDTO?> GetByIdAsync(int id)
		{
			//var exampleModel = await _context.ExampleModels.FindAsync(id);

			try
			{
				var exampleModel = await _nosqlrepo.GetByIdAsync(id);

				return new ExampleDTO(exampleModel);
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}

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

			try
			{
				await _nosqlrepo.AddAsync(exampleModel);
				return new ExampleDTO(exampleModel);
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}

			//portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);

		}

		public async Task<ExampleDTO?> UpdateAsync(int id, ExampleDTO updatedExampleDTO)
		{
			var updatedExampleModel = new NosqlExampleModel(updatedExampleDTO);

			try
			{
				var exampleModel = await _nosqlrepo.GetByIdAsync(id);
				await _nosqlrepo.UpdateAsync(id, updatedExampleModel);
				return new ExampleDTO(updatedExampleModel);
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}

			//if (exampleModel is null) return null;
		}

		public async Task<ExampleDTO?> DeleteAsync(int id)
		{
			try
			{
				var exampleModel = await _nosqlrepo.GetByIdAsync(id);
				await _nosqlrepo.DeleteAsync(id);
				return new ExampleDTO(exampleModel);
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}

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
