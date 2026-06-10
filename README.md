# template-builder-oracle

This template creates a Docker image that enables integration of .NET Core 3.1 with Oracle. To use the Oracle.ManagedDataAccess library from our applications, it's necessary to install the Oracle Client to make database calls from our web application.

The version being installed is Oracle Instant Client 19.8.

## Oracle InstantClient Installation Information

It's important to stay updated with Oracle provider updates. The download information can be found at: [Oracle Instant Client Downloads](https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html)

## Files

Inside the `Network/Admin` folder, you can place access keys if you need to connect to Oracle Cloud. If your Oracle installation is on-premise, there won't be any issues - just configure the connection strings within your application.

## Usage Examples

### Building the Docker Image

```bash
docker build -t my-oracle-app .
```

### Running the Container

```bash
docker run -d \
  --name oracle-app \
  -p 8080:80 \
  -v $(pwd)/oracle/wallet:/opt/oracle/instantclient_23_26/network/admin \
  my-oracle-app
```

### Connection String Configuration (appsettings.json)

```json
{
  "ConnectionStrings": {
    "OracleConnection": "User Id=myuser;Password=mypassword;Data Source=tns_bd_name;"
  }
}
```

### Using Oracle.ManagedDataAccess in .NET Core

```csharp
using Oracle.ManagedDataAccess.Client;

public class OracleService
{
    private readonly string _connectionString;

    public OracleService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("OracleConnection");
    }

    public async Task<List<User>> GetUsersAsync()
    {
        var users = new List<User>();
        
        using (var connection = new OracleConnection(_connectionString))
        {
            await connection.OpenAsync();
            
            using (var command = new OracleCommand("SELECT * FROM USERS", connection))
            using (var reader = await command.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    users.Add(new User
                    {
                        Id = reader.GetInt32(0),
                        Name = reader.GetString(1),
                        Email = reader.GetString(2)
                    });
                }
            }
        }
        
        return users;
    }
}
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  oracle-app:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./Network/Admin:/app/Network/Admin
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
    depends_on:
      - oracle-db

  oracle-db:
    image: oracle/database:19.3.0-ee
    ports:
      - "1521:1521"
    environment:
      - ORACLE_PWD=Oradoc_db1
```