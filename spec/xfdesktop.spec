Name:           xfdesktop
Version:        4.20.0
Release:        1%{?dist}
Summary:        Desktop manager for the Xfce Desktop Environment

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfdesktop/4.20/xfdesktop-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  exo-devel >= 4.20.0
BuildRequires:  garcon-devel >= 4.20.0
BuildRequires:  libxfce4windowing-devel >= 4.20.0
BuildRequires:  libX11-devel
BuildRequires:  libwnck3-devel
BuildRequires:  libnotify-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
The Xfce Desktop Manager is a tool to manage the desktop background
and to provide it with icons and a menu.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%find_lang xfdesktop

%files -f xfdesktop.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfdesktop
%{_bindir}/xfdesktop-settings
%{_datadir}/applications/xfce-backdrop-settings.desktop
%{_datadir}/backgrounds/xfce/
%{_datadir}/icons/hicolor/*/apps/org.xfce.xfdesktop.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.xfdesktop.svg

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
