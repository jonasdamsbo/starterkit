using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using myshared.Models;

namespace myapi.Data
{
    public class MssqlDataContext : DbContext
    {
        public MssqlDataContext(DbContextOptions<MssqlDataContext> options) : base (options)
        {
        }

		public DbSet<ExampleModel> ExampleModels => Set<ExampleModel>();
		public DbSet<ExampleNavigationProperty> ExampleNavigationProperties => Set<ExampleNavigationProperty>();

		protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // define relations
			modelBuilder.Entity<ExampleModel>()
                .HasMany(x => x.ExampleNavigationProperty)
                .WithOne(x => x.ExampleModel)
                .HasForeignKey(x => x.ExampleModelId)
                .IsRequired();

            modelBuilder.Entity<ExampleNavigationProperty>()
                .HasOne(x => x.ExampleModel)
                .WithMany(x => x.ExampleNavigationProperty);


            // dummy data
			List<ExampleModel> exampleList = new List<ExampleModel>();
			List<ExampleNavigationProperty> navPropList = new List<ExampleNavigationProperty>();

			exampleList.Add(new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), Title = "First example", Description = "Some field of first example", WebUrl = "google.dk", ExampleNavigationProperty = new List<ExampleNavigationProperty>() });
			exampleList.Add(new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), Title = "Second example", Description = "Some field of second example", WebUrl = "google.dk", ExampleNavigationProperty = new List<ExampleNavigationProperty>() });
			exampleList.Add(new ExampleModel { Id = ObjectId.GenerateNewId().ToString(), Title = "Third example", Description = "Some field of third example", WebUrl = "google.dk", ExampleNavigationProperty = new List<ExampleNavigationProperty>() });

            navPropList.Add(new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "First navprop", ExampleModelId = exampleList[0].Id });
            navPropList.Add(new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "Second navprop", ExampleModelId = exampleList[0].Id });
            navPropList.Add(new ExampleNavigationProperty { Id = ObjectId.GenerateNewId().ToString(), Title = "Third navprop", ExampleModelId = exampleList[1].Id });

            //exampleList[0].ExampleNavigationProperty.Add(navPropList[0]);
			//exampleList[1].ExampleNavigationProperty.Add(navPropList[1]);
			//exampleList[1].ExampleNavigationProperty.Add(navPropList[2]);

            modelBuilder.Entity<ExampleModel>().HasData(exampleList);

            modelBuilder.Entity<ExampleNavigationProperty>().HasData(navPropList);

            //modelBuilder.Entity<ExampleModel>();
            //modelBuilder.Entity<ExampleModel>().ToTable("ExampleModels");
        }
    }
}
