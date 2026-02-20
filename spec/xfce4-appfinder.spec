Name:           xfce4-appfinder
Version:        4.20.0
Release:        1%{?dist}
Summary:        Application finder for the Xfce Desktop Environment

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfce4-appfinder/4.20/xfce4-appfinder-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  garcon-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
The Application Finder is a tool to find and launch applications and
commands on your system.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%find_lang xfce4-appfinder

%files -f xfce4-appfinder.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-appfinder
%{_bindir}/xfrun4
%{_datadir}/applications/org.xfce.appfinder.desktop
%{_datadir}/applications/org.xfce.run.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.appfinder.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.appfinder.svg

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
