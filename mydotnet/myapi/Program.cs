using EFCore.AutomaticMigrations;
using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myapi.Endpoints;
using myapi.Repositories;
using myapi.Services;
using myshared.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container. // standard

// controller - outcomment to use endpoints v
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();
builder.Services.AddSwaggerGen(c =>
{
	// use these options to avoid swagger error when endpoint/controller methods has same names
	c.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());
});

// mssql database context and connectionstring
builder.Services.AddDbContext<MssqlDataContext>(options =>
	options.UseSqlServer(builder.Configuration.GetConnectionString("Mssql")));
	//.EnableSensitiveDataLogging(true));

// nosql database context and connectionstring/section in appsettings.cs
builder.Services.AddScoped<NosqlDataContext>();
builder.Services.Configure<NosqlDataContext>(
	builder.Configuration.GetSection("NosqlDatabase"));

// add services
builder.Services.AddScoped<ExampleService>();
builder.Services.AddScoped<ExampleNavPropService>();
//builder.Services.AddSingleton<ExampleService>();
//builder.Services.AddSingleton<ILogger>();
builder.Services.AddScoped<BackupDBService>();
builder.Services.AddScoped<EnvironmentVariableService>();

// add repositories
builder.Services.AddScoped<ExampleModelRepository>();
builder.Services.AddScoped<ExampleNavigationPropertyRepository>();

// to run/deploy 2 projects in a single app
builder.Services.Configure<IISOptions>(options =>
{
	options.ForwardClientCertificate = false;
});

//builder.Services.AddScoped<EnvironmentVariableService>();
//builder.Services.AddScoped<BackupService>();

// minimal api
//builder.Services.AddDbContext<DataContext>(opt => opt.UseInMemoryDatabase("PortfolioProjects"));

// build app
var app = builder.Build();

// update-database on build
using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;

	// backup db if on production env
	var backupDbService = services.GetRequiredService<BackupDBService>();
    backupDbService.InitBackup();
    //await backupDbService.InitBackup();

    // check nosql db if db and collections exists, if not, create
    var nosqlcontext = services.GetRequiredService<NosqlDataContext>();
	nosqlcontext.Initialize();

	// using your manually created migrations, automatically runs update-database 
	var context = services.GetRequiredService<MssqlDataContext>();
    context.Database.Migrate();

	// runs update-database without the need for migrations
	//MigrateDatabaseToLatestVersion.Execute(context, new DbMigrationsOptions { AutomaticMigrationDataLossAllowed = true });

	//context.Database.EnsureCreated();
	//context.Database.Migrate();

	// without having to manually create migrations, fully automatic, requires NuGet EFCode.AutomaticMigrations
	// without options 
	//MigrateDatabaseToLatestVersion.Execute(context);
	//var envVarService = services.GetRequiredService<EnvironmentVariableService>();
	//Console.WriteLine(envVarService.GetConnStr());

	// with options
	/*try
	{
		MigrateDatabaseToLatestVersion.Execute(context,
			new DbMigrationsOptions
			{
				AutomaticMigrationsEnabled = true,
				AutomaticMigrationDataLossAllowed = true
			}
		);
	}
	catch (Exception e){
		Console.WriteLine(e.ToString());
	}*/

	//Console.WriteLine(envVarService.GetConnStr()); 

	//var backupService = services.GetRequiredService<BackupService>();
	//backupService.BackupDb();
}

// Configure the HTTP request pipeline. 
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}

app.UseHttpsRedirection();


// controllers - incomment this and outcomment below to use controllers v
app.UseAuthorization();
app.MapControllers();

// minimal api endpoints - outcomment this and incomment above to use controllers ^
//app.MapExampleModelEndpoints();
/*app.MapGroup("/portfolioprojects")
	.MapPortfolioProjectsEndpoints()
	.WithTags("Public");*/

app.Run();

/*using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;
	var envVarService = services.GetRequiredService<EnvironmentVariableService>();
	Console.WriteLine(envVarService.GetConnStr());
}*/