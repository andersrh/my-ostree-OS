Name:           xfce4-settings
Version:        4.20.0
Release:        1%{?dist}
Summary:        Settings manager for the Xfce Desktop Environment

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfce4-settings/4.20/xfce4-settings-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  exo-devel >= 4.20.0
BuildRequires:  libxfce4windowing-devel >= 4.20.0
BuildRequires:  libX11-devel
BuildRequires:  libXcursor-devel
BuildRequires:  libXi-devel
BuildRequires:  libXrandr-devel
BuildRequires:  libXft-devel
BuildRequires:  libnotify-devel
BuildRequires:  libxklavier-devel
BuildRequires:  upower-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
The Xfce Settings Manager is a tool to configure the Xfce desktop
environment.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%find_lang xfce4-settings

%files -f xfce4-settings.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-accessibility-settings
%{_bindir}/xfce4-appearance-settings
%{_bindir}/xfce4-display-settings
%{_bindir}/xfce4-keyboard-settings
%{_bindir}/xfce4-mime-settings
%{_bindir}/xfce4-mouse-settings
%{_bindir}/xfce4-settings-editor
%{_bindir}/xfce4-settings-manager
%{_libdir}/xfce4/settings/
%{_sysconfdir}/xdg/autostart/xfsettingsd.desktop
%{_sysconfdir}/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
%{_datadir}/applications/*.desktop
%{_datadir}/icons/hicolor/*/apps/*.png
%{_datadir}/icons/hicolor/*/apps/*.svg

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
