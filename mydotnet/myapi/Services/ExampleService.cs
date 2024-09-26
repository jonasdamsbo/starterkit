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

		public async Task<IResult> GetAllAsync()
		{
			//var exampleModels = await _context.ExampleModels.ToListAsync();

			var exampleModels = await _nosqlrepo.GetAllAsync();
			var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();

			return TypedResults.Ok(exampleDTOs);
		}

		public async Task<IResult> GetByIdAsync(int id)
		{
			//var exampleModel = await _context.ExampleModels.FindAsync(id);
			var exampleModel = await _nosqlrepo.GetByIdAsync(id);

			//if (exampleModel == null)
			//{
			//	return NotFound();
			//}

			var exampleDTO = new ExampleDTO(exampleModel);

			return await _nosqlrepo.GetByIdAsync(id)
				is NosqlExampleModel
					? TypedResults.Ok(exampleDTO)
					: TypedResults.NotFound();
		}

		public async Task<IResult> AddAsync(ExampleDTO exampleDTO)
		{
			/*var portfolioProjectDTO = new PortfolioProjectDTO
			{
				Title = portfolioProjectDTO.Title,
				Description = portfolioProjectDTO.Description
			};*/

			var exampleModel = new NosqlExampleModel(exampleDTO);
			await _nosqlrepo.AddAsync(exampleModel);

			//portfolioProjectDTO = new PortfolioProjectDTO(portfolioProject);

			return TypedResults.Created($"/exampleModels/{exampleDTO.Id}", exampleDTO);
		}

		public async Task<IResult> UpdateAsync(int id, ExampleDTO updatedExampleDTO)
		{
			var exampleModel = await _nosqlrepo.GetByIdAsync(id);

			if (exampleModel is null) return TypedResults.NotFound();

			var updatedExampleModel = new NosqlExampleModel(updatedExampleDTO);
			await _nosqlrepo.UpdateAsync(id, updatedExampleModel);

			return TypedResults.NoContent();
		}

		public async Task<IResult> DeleteAsync(int id)
		{
			if (await _nosqlrepo.GetByIdAsync(id) is NosqlExampleModel)
			{
				await _nosqlrepo.DeleteAsync(id);
				return TypedResults.NoContent();
			}

			return TypedResults.NotFound();
		}
	}
}
