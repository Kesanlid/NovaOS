# Contributing to NovaOS

Thank you for your interest in contributing to NovaOS!

## 🚀 Getting Started

### Prerequisites

- Arch Linux or NovaOS installed
- `archiso` package installed
- Basic understanding of Linux system administration

### Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/novaos.git
   cd novaos
   ```

3. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Guidelines

### Package Contributions

When adding packages:
- Ensure packages are in official Arch repositories or trusted AUR packages
- Include package purpose in comments
- Alphabetically sort packages within categories

### Theme Contributions

When contributing themes:
- Maintain visual consistency with NovaOS branding
- Test on both light and dark modes
- Include all required assets (icons, cursors, etc.)

### Build System Changes

When modifying build scripts:
- Test thoroughly with `--debug` flag
- Ensure backward compatibility
- Document any new build options

## 🔍 Code Review Process

1. Create a pull request with clear description
2. Ensure CI/CD passes (if applicable)
3. Wait for review from maintainers
4. Address feedback constructively

## 📋 Issue Reporting

When reporting bugs:
- Use GitHub Issues
- Include system information (`inxi -Fxxx`)
- Include steps to reproduce
- Include relevant logs

## 💬 Communication

- GitHub Discussions
- IRC: #novaos on Libera.Chat

## 📜 License

By contributing, you agree that your contributions will be licensed under the GPL-3.0 License.
