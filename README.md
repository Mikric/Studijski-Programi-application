\# Study Program Structure



A web application for defining the structure of study programs: modules, subjects and elective positions. Client and server are separate applications.



\## Tech stack

\- Server: Java 21, Spring Boot, Spring Data JPA (Hibernate), PostgreSQL, REST API

\- Client: Spring Boot, JSP, Bootstrap, JavaScript



\## Features

\- CRUD for study programs, modules and subjects

\- The same subject can be offered on several programs

\- Elective positions

\- Export of a study program to PDF



\## How to run

1\. Create a PostgreSQL database.

2\. Copy `application-local.properties.example` to `application-local.properties` and enter your database credentials.

3\. Start the server: `mvnw.cmd spring-boot:run` (in the server folder).

4\. Start the client the same way (in the client folder) and open http://localhost:8081/programi

