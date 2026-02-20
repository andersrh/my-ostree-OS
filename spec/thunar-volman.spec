Name:           thunar-volman
Version:        4.20.0
Release:        1%{?dist}
Summary:        Volume manager for Thunar

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/thunar-volman/4.20/thunar-volman-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  exo-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  gudev-devel
BuildRequires:  libnotify-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
Thunar Volman is an extension for the Thunar File Manager, which enables
automatic management of removable drives and media.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%find_lang thunar-volman

%files -f thunar-volman.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/thunar-volman
%{_bindir}/thunar-volman-settings
%{_datadir}/applications/thunar-volman-settings.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.volman.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.volman.svg

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
