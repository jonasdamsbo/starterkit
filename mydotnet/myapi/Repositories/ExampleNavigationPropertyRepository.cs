using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;
using myapi.Data;
using myshared.Models;
using System.Linq;

namespace myapi.Repositories
{
	public class ExampleNavigationPropertyRepository// : IRepository // Combined to be nosql/mssql agnostic
	{
		//private readonly MssqlDataContext _context;
		//private readonly NosqlDataContext _context;
		private readonly dynamic _context;

		// repo is database agnostic, flip to use nosql/mssql database
		public ExampleNavigationPropertyRepository(MssqlDataContext context)
		{
			_context = context;
		}

		public async Task<List<ExampleNavigationProperty>> GetAllAsync()
		{
			try
			{

				//
				var examples = new List<ExampleNavigationProperty>();
				if (_context is MssqlDataContext)
				{
					examples = await (_context as MssqlDataContext).ExampleNavigationProperties
						.Include(x => x.ExampleModel)
						.ToListAsync();
				}
				else
				{
					await (_context as NosqlDataContext).ExampleModels.Find(_ => true).ForEachAsync(x => x.ExampleNavigationProperty.ForEach(x => examples.Add(x)));
					//var examples = await _context.ExampleNavigationProperties.Find(_ => true).ToListAsync();
					// cant include
				}

				if (examples is null) return new List<ExampleNavigationProperty>();

				return examples;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		// should be in all repositories whos model uses a foreign key
		public async Task<List<ExampleNavigationProperty>> GetAllRelatedToIdAsync(string exampleModelId)
		{
			try
			{

				//
				var exampleNavProps = new List<ExampleNavigationProperty>();
				if (_context is MssqlDataContext)
				{
					exampleNavProps = await (_context as MssqlDataContext).ExampleNavigationProperties
						.Where(x => x.ExampleModel.Id == exampleModelId)
						.Include(x => x.ExampleModel)
						.ToListAsync();
				}
				else
				{
					exampleNavProps = (await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == exampleModelId.ToString()).FirstOrDefaultAsync()).ExampleNavigationProperty;
					//exampleNavProps = await (_context as NosqlDataContext).ExampleNavigationProperties
					//	.Find(x => x.ExampleModel.Id == exampleModelId)
					//	.ToListAsync();
					// nosql include
					//var exampleModel = await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == exampleModelId).FirstOrDefaultAsync();
					//exampleNavProps.ForEach(x => x.ExampleModel = exampleModel);
				}

				if (exampleNavProps is null) return new List<ExampleNavigationProperty>();

				return exampleNavProps;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<ExampleNavigationProperty> GetByIdAsync(string id)
		{
			try
			{

				//
				var exampleNavProp = new ExampleNavigationProperty();
				if (_context is MssqlDataContext)
				{
					exampleNavProp = await (_context as MssqlDataContext).ExampleNavigationProperties
						.Where(x => x.ExampleModel.Id == id)
						.Include(x => x.ExampleModel)
						.FirstOrDefaultAsync();
				}
				else
				{
					var proplist = new List<ExampleNavigationProperty>();
					await (_context as NosqlDataContext).ExampleModels.Find(_ => true).ForEachAsync(x => x.ExampleNavigationProperty.ForEach(x => proplist.Add(x)));
					exampleNavProp = proplist.Where(x => x.Id == id).FirstOrDefault();
					//exampleNavProp = await (_context as NosqlDataContext).ExampleNavigationProperties
					//	.Find(x => x.Id == id.ToString())
					//	.FirstOrDefaultAsync();
					// nosql include
					//var exampleModel = await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == id).FirstOrDefaultAsync();
					//exampleNavProp.ExampleModel = exampleModel;
				}

				if (exampleNavProp is null) return new ExampleNavigationProperty();

				return exampleNavProp;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<ExampleNavigationProperty> AddAsync(ExampleNavigationProperty newModel)
		{
			try
			{
				newModel.Id = ObjectId.GenerateNewId().ToString();

				//
				if (_context is MssqlDataContext)
				{
					(_context as MssqlDataContext).Add(newModel);
					await (_context as MssqlDataContext).SaveChangesAsync();
				}
				else
				{
					var exampleModel = await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == newModel.ExampleModelId.ToString()).FirstOrDefaultAsync();
					exampleModel.ExampleNavigationProperty.Add(newModel);
					await (_context as NosqlDataContext).ExampleModels.ReplaceOneAsync(x => x.Id == newModel.ExampleModelId.ToString(), exampleModel);
					//await (_context as NosqlDataContext).ExampleNavigationProperties.InsertOneAsync(newModel);
				}

				var example = await GetByIdAsync(newModel.Id);

				if (example is null) return new ExampleNavigationProperty();

				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<ExampleNavigationProperty> UpdateAsync(string id, ExampleNavigationProperty updatedModel)
		{
			try
			{
				var example = await GetByIdAsync(id);
				if (example != null)
				{

					//
					if (_context is MssqlDataContext)
					{
						example.Title = updatedModel.Title;

						await (_context as MssqlDataContext).SaveChangesAsync();
					}
					else
					{
						var exampleModel = await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == updatedModel.ExampleModelId.ToString()).FirstOrDefaultAsync();
						var navProp = exampleModel.ExampleNavigationProperty.FirstOrDefault(x => x.Id == id);
						navProp = updatedModel;
						await (_context as NosqlDataContext).ExampleModels.ReplaceOneAsync(x => x.Id == exampleModel.Id.ToString(), exampleModel);

						//await (_context as NosqlDataContext).ExampleNavigationProperties.ReplaceOneAsync(x => x.Id == id.ToString(), updatedModel);
					}

					example = await GetByIdAsync(id);
				}

				if (example is null) return new ExampleNavigationProperty();

				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<ExampleNavigationProperty> DeleteAsync(string id)
		{
			try
			{
				var example = await GetByIdAsync(id);
				if (example != null)
				{

					//
					if (_context is MssqlDataContext)
					{
						_context.ExampleNavigationProperties.Remove(example);
						await (_context as MssqlDataContext).SaveChangesAsync();
					}
					else
					{
						var proplist = new List<ExampleNavigationProperty>();
						await (_context as NosqlDataContext).ExampleModels.Find(_ => true).ForEachAsync(x => x.ExampleNavigationProperty.ForEach(x => proplist.Add(x)));
						var navProp = proplist.Where(x => x.Id == id).FirstOrDefault();

						var exampleModel = await (_context as NosqlDataContext).ExampleModels.Find(x => x.Id == navProp.ExampleModelId.ToString()).FirstOrDefaultAsync();
						exampleModel.ExampleNavigationProperty.Remove(navProp);
						await (_context as NosqlDataContext).ExampleModels.ReplaceOneAsync(x => x.Id == exampleModel.Id.ToString(), exampleModel);
						//await (_context as NosqlDataContext).ExampleNavigationProperties.DeleteOneAsync(x => x.Id == id.ToString());
					}

				}

				if (example is null) return new ExampleNavigationProperty();

				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		// ### nosql repo simple version: ###

		//public async Task<List<NosqlExampleModel>> GetAllAsync() =>
		//	await _nosqlExampleCollection.Find(_ => true).ToListAsync();

		//public async Task<NosqlExampleModel> GetByIdAsync(int id) =>
		//	await _nosqlExampleCollection.Find(x => x.Id == id).FirstOrDefaultAsync();

		//public async Task AddAsync(NosqlExampleModel newModel) =>
		//	await _nosqlExampleCollection.InsertOneAsync(newModel);

		//public async Task UpdateAsync(int id, NosqlExampleModel updatedModel) =>
		//	await _nosqlExampleCollection.ReplaceOneAsync(x => x.Id == id, updatedModel);

		//public async Task DeleteAsync(int id) =>
		//	await _nosqlExampleCollection.DeleteOneAsync(x => x.Id == id);
	}
}
