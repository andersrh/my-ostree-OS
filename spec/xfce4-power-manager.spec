Name:           xfce4-power-manager
Version:        4.20.0
Release:        1%{?dist}
Summary:        Power manager for the Xfce desktop environment

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfce4-power-manager/4.20/xfce4-power-manager-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libxfce4windowing-devel >= 4.20.0
BuildRequires:  libnotify-devel
BuildRequires:  upower-devel
BuildRequires:  xfce4-panel-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
The Xfce Power Manager is a tool to manage the power consumption of
the Xfce desktop environment.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%find_lang xfce4-power-manager

%files -f xfce4-power-manager.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-power-manager
%{_bindir}/xfce4-power-manager-settings
%{_sysconfdir}/xdg/autostart/xfce4-power-manager.desktop
%{_datadir}/applications/xfce4-power-manager-settings.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.powermanager.png
%{_libdir}/xfce4/panel/plugins/libxfce4powermanager*

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
