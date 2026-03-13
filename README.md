# stormer.octopus.app.mainframes

A repository for storing mainframe source code, including COBOL programs, JCL scripts, and REXX procedures. This repository is integrated with Octopus Deploy for automated deployment to mainframe environments.

## Repository Structure

```
stormer.octopus.app.mainframes/
├── src/
│   └── cobol/          # COBOL source programs
├── jcl/                # Job Control Language scripts
│   ├── compile/        # Compilation JCL
│   └── run/            # Execution JCL
├── rexx/               # REXX exec procedures
└── .octopus/           # Octopus Deploy configuration
```

## Languages & Technologies

| Type | Description |
|------|-------------|
| COBOL | Business application programs |
| JCL | Job Control Language for batch processing |
| REXX | Scripting and utility procedures |

## Getting Started

### Prerequisites

- Access to an IBM z/OS mainframe environment (or emulator such as [Hercules](http://www.hercules-390.eu/))
- IBM Enterprise COBOL compiler (or compatible open-source compiler such as [GnuCOBOL](https://gnucobol.sourceforge.io/))
- Octopus Deploy with a mainframe deployment target configured

### Building and Running

1. **Compile a COBOL program** using the provided JCL:
   ```
   Submit: jcl/compile/COMPILE.jcl
   ```

2. **Run a program** using the execution JCL:
   ```
   Submit: jcl/run/RUN.jcl
   ```

3. **Execute a REXX script** directly from ISPF or TSO:
   ```
   EXEC 'STORMER.REXX(HELLO)'
   ```

## Deployment with Octopus Deploy

This repository is configured for use with [Octopus Deploy](https://octopus.com/). The `.octopus/` folder contains the deployment process definition. To deploy:

1. Push changes to this repository.
2. The CI pipeline packages the artifacts and pushes them to Octopus.
3. Octopus deploys to the target mainframe environment.

## Contributing

1. Create a new branch from `main`.
2. Make your changes and commit them.
3. Open a pull request for review.

## License

See [LICENSE](LICENSE) for details.
