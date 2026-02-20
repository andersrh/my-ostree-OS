Name:           xfce4-dev-tools
Version:        4.20.0
Release:        1%{?dist}
Summary:        Development tools for Xfce

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfce4-dev-tools/4.20/xfce4-dev-tools-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool
BuildRequires:  libxslt
BuildRequires:  meson
BuildRequires:  glib2-devel

%description
Development tools for the Xfce desktop environment.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%files
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce-do-release
%{_bindir}/xfce-get-release-notes
%{_bindir}/xfce-get-translations
%{_bindir}/xfce-update-news
%{_bindir}/xfce-build
%{_bindir}/xdt-autogen
%{_bindir}/xdt-csource
%{_bindir}/xdt-check-abi
%{_bindir}/xdt-gen-visibility
%{_datadir}/aclocal/xdt-*.m4
%{_mandir}/man1/xdt-csource.1*

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
