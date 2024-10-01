{
  services.nginx = {
    enable = true;
    config = ''
      server {
          listen 80;
          server_name site1.domain.example;

          location / {
              proxy_pass http://localhost:8080;
          }
      }

      server {
          listen 80;
          server_name site2.domain.example;

          location / {
              proxy_pass http://localhost:8081;
          }
      }
    '';
  };
}
