using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Proxies;
using myapi.Data;
using myshared.Models;
using myapi.Extensions;

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

// automapper and mapster
// automapper
//builder.Services.AddAutoMapper(typeof(Program).Assembly);
// mapster
builder.Services.AddScoped<MapsterConfig>();


// mssql database context and connectionstring

// for mssql
builder.Services.AddDbContext<MssqlDataContext>(options => options
   .UseSqlServer(builder.Configuration.GetConnectionString("Mssql"))//);
   .UseLazyLoadingProxies()); // for enabling lazy loading
//.EnableSensitiveDataLogging(true));

// for sqlite
//builder.Services.AddDbContext<MssqlDataContext>(options =>
//	options.UseSqlite(builder.Configuration.GetConnectionString("Sqlite")));


//// add services
////builder.Services.AddScoped<AzureUtility>();
//builder.Services.AddScoped<EnvironmentVariableService>();
//builder.Services.AddScoped<ExampleModelService>();
//builder.Services.AddScoped<ExampleNavigationPropertyService>();
//builder.Services.AddScoped<BackupDbUtility>();

//// add repositories
//builder.Services.AddScoped<IExampleModelRepository, ExampleModelRepository>();
//builder.Services.AddScoped<ExampleNavigationPropertyRepository>();

// add servicecollection
builder.Services.RegisterServices();

// to run/deploy 2 projects in a single app
builder.Services.Configure<IISOptions>(options =>
{
	options.ForwardClientCertificate = false;
});

// "no route matches" error v
builder.Services.AddMvc(options =>
{
	options.SuppressAsyncSuffixInActionNames = false;
});
// "no route matches" error ^

// angular v
builder.Services.AddCors(options =>
{
	options.AddPolicy("AllowAll", policy =>
	{
		policy.AllowAnyOrigin()
			  .AllowAnyHeader()
			  .AllowAnyMethod();
	});
});
// angular ^

// build app
var app = builder.Build();

// angular v
app.UseCors("AllowAll");
// angular ^

// update-database on build
using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;
	
	// test azure cli/devops
	//var azure = services.GetRequiredService<AzureUtility>();
    //var x = azure.GetResourcesList();

	// backup db if on production env
	/*var backupDbService = services.GetRequiredService<BackupDbUtility>();
    backupDbService.InitBackup();*/

    // using your manually created migrations, automatically runs update-database 
    /*var context = services.GetRequiredService<MssqlDataContext>();
    context.Database.Migrate();*/

	// mapster
	var mapster = services.GetRequiredService<MapsterConfig>();
	mapster.ConfigureMapster();
}

// Configure the HTTP request pipeline. 
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();
app.MapControllers();

app.Run();