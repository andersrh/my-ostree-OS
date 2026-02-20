Name:           xfce4-clipman-plugin
Version:        1.7.0
Release:        1%{?dist}
Summary:        Clipboard manager plugin for the Xfce panel

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/panel-plugins/xfce4-clipman-plugin/1.7/xfce4-clipman-plugin-%{version}.tar.xz

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  xfce4-panel-devel >= 4.20.0
BuildRequires:  libXtst-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
Xfce4-clipman-plugin is a clipboard manager plugin for the Xfce panel.

%prep
%autosetup

%build
xdt-autogen
%configure
%make_build

%install
%make_install

%find_lang xfce4-clipman-plugin

%files -f xfce4-clipman-plugin.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-clipman
%{_bindir}/xfce4-clipman-settings
%{_libdir}/xfce4/panel/plugins/libclipman*
%{_datadir}/applications/xfce4-clipman.desktop
%{_datadir}/applications/xfce4-clipman-settings.desktop
%{_datadir}/xfce4/panel/plugins/clipman.desktop
%{_datadir}/icons/hicolor/*/apps/xfce4-clipman.png
%{_datadir}/icons/hicolor/*/apps/xfce4-clipman.svg

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 1.7.0-1
- Initial release for Xfce 4.20 compatibility
